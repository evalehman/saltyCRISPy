
import pickle
import pandas as pd
from tap import Tap

from haloclass.publish.generate_embeddings import ImportedFasta, checkpoint150
from pathlib import Path

from haloclass.publish.use_model import evaluate_model

# Changed fasta to fasta_dir and save to save_dir
# changed predictions.csv to predictions directory
class UseModelSimpleArgs(Tap):
    model_path: str = f"{Path(__file__).parent.parent.parent.absolute()}/publication-datasets/model.pkl"
    fasta_dir: str
    save_dir: str = "predictions"
    print_perf: bool = False
    disable_accelerators: bool = False
    batch_size: int = 32

# Changed lines 24-26
# Added line 27 (MAYBE REMOVE)
def main():
    args = UseModelSimpleArgs().parse_args()
    fasta_dir = Path(args.fasta_dir)
    save_dir = Path(args.save_dir)
    save_dir.mkdir(exist_ok=True)

    with open(args.model_path, "rb") as f:
        model = pickle.load(f)
    
    sequence_derivation = "default" if args.print_perf else 0

# Added a for loop
    for fasta_file in fasta_dir.glob("*.faa"):

        combined = ImportedFasta.from_fasta(fasta_file, sequence_derivation)
        embeddings = checkpoint150(combined.sequences, combined.labels, disable_accelerators=args.disable_accelerators, batch_size=args.batch_size)

        if args.print_perf:
            print("=" * 50)
            print(f"MODEL PERFORMANCE for {fasta_file.name}:")
            print(evaluate_model(model, embeddings, combined.labels))
            print("=" * 50)
    
        predictions = model.predict(embeddings)

        decisions = [("non-tolerant" if p == 0 else "salt-tolerant") for p in predictions]
    
        df = pd.DataFrame({ "sequences": combined.sequences, "predicted labels": decisions, "predictions": predictions, "confidences": model.predict_proba(embeddings)[:,1] })
    
    # Prediction outputs are named after input file
        predictions_output = save_dir / f"{fasta_file.stem}.csv"
        df.to_csv(predictions_output, index=False)

        print(f"Saved: {predictions_output.absolute()}")


    print("All files processed")

if __name__ == "__main__":
    main()