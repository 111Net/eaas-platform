#!/bin/bash

echo "🚀 EAAS GitFlow Initialization Starting..."

# Ensure we are in a git repo
if [ ! -d .git ]; then
  echo "❌ Not a git repository. Run git init first."
  exit 1
fi

# Step 1: Ensure main branch exists and is clean
echo "📦 Setting up main branch..."
git checkout -B main
git add .
git commit -m "EAAS initial stable commit" || echo "No changes to commit"
git push -u origin main

# Step 2: Create development branch
echo "🛠 Creating development branch..."
git checkout -B development
git push -u origin development

# Step 3: Create staging branch from main
echo "🧪 Creating staging branch..."
git checkout main
git checkout -B staging
git push -u origin staging

# Step 4: Return to development (default working branch)
git checkout development

# Step 5: Verify branches
echo "🔍 Local branches:"
git branch

echo "🌍 Remote branches:"
git branch -r

echo "✅ EAAS GitFlow setup complete!"
echo "👉 main = production"
echo "👉 staging = investor demos"
echo "👉 development = active coding"
