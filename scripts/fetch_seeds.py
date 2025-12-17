"""
Offline-friendly placeholder for fetching seeds.

Replace URL fetches with your approved sources.
Run: python scripts/fetch_seeds.py
"""
import csv, os, datetime

BASE = os.path.dirname(os.path.dirname(__file__))
SEEDS = os.path.join(BASE, "seeds")

def write_csv(path, rows):
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerows(rows)

if __name__ == "__main__":
    # Example: append a changelog entry (for your pipeline to consume later)
    changelog = os.path.join(SEEDS, "seed_changelog.csv")
    now = datetime.datetime.utcnow().isoformat()
    if not os.path.exists(changelog):
        write_csv(changelog, [["timestamp","seed","action","notes"]])
    with open(changelog, "a", newline="", encoding="utf-8") as f:
        csv.writer(f).writerow([now, "bootstrap", "init", "Initialized local seeds"])
    print("Wrote seeds changelog at", changelog)
