
import pickle
import pandas as pd
from tap import Tap

from haloclass.publish.generate_embeddings import ImportedFasta, checkpoint150
from pathlib import Path

from haloclass.publish.use_model import evaluate_model

# Changed fasta to fasta_dir and save to save_dir and predictions.csv to predictions directory
class UseModelSimpleArgs(Tap):
    model_path: str = f"{Path(__file__).parent.parent.parent.absolute()}/publication-datasets/model.pkl"
    fasta_dir: str
    save_dir: str = "predictions"
    print_perf: bool = False
    disable_accelerators: bool = False
    batch_size: int = 32

# Input= dir instead of .fasta
def main():
    args = UseModelSimpleArgs().parse_args()
    
    fasta_dir = Path(args.fasta_dir)
    save_dir = Path(args.save_dir)
    save_dir.mkdir(parents=True, exist_ok=True)
    
    if not fasta_dir.exists() or not fasta_dir.is_dir():
        raise ValueError(f"Invalid fasta_dir: {fasta_dir}")
        
# Load trained model
    with open(args.model_path, "rb") as f:
        model = pickle.load(f)
    
    sequence_derivation = "default" if args.print_perf else 0

# Store FASTA files first
    fasta_files = list(fasta_dir.glob("*.fa*"))
    if not fasta_files:
        print("No FASTA files found.")
        return
        
# Process each Fasta file   
    for fasta_file in fasta_files:
        predictions_output = save_dir / f"{fasta_file.stem}.csv"

         # Skip file if already processed
        if predictions_output.exists():
            print(f"Skipping {fasta_file.name} (already processed)")
            continue  
            
        print(f"Processing: {fasta_file.name}")
        
        combined = ImportedFasta.from_fasta(fasta_file, sequence_derivation)
        embeddings = checkpoint150(combined.sequences, combined.labels, disable_accelerators=args.disable_accelerators, batch_size=args.batch_size)

        if args.print_perf:
            print("=" * 50)
            print(f"MODEL PERFORMANCE for {fasta_file.name}:")

            if combined.labels is not None:
                print(evaluate_model(model, embeddings, combined.labels))
            else:
                print("No labels available; skipping performance evaluation")
            print("=" * 50)
    
        predictions = model.predict(embeddings)

        # Check model supports probability predictions
        if not hasattr(model, "predict_proba"):
            raise AttributeError("Model does not support predict_proba")

        proba = model.predict_proba(embeddings)
        
        if proba.shape[1] != 2:
            raise ValueError("Expected binary classifier probabilities")        
            
        decisions = [("non-tolerant" if p == 0 else "salt-tolerant") for p in predictions]
        df = pd.DataFrame({ "sequences": combined.sequences, "predicted labels": decisions, "predictions": predictions, "confidences": model.predict_proba(embeddings)[:,1] })
    
    
        df.to_csv(predictions_output, index=False)
        print(f"Saved: {predictions_output.absolute()}")

    print("All files processed")

if __name__ == "__main__":
    main()
