#!/bin/bash

# THRIVEMIND Setup Script
# This script sets up both frontend and backend for the THRIVEMIND application

echo "🧠 THRIVEMIND Setup Script"
echo "=========================="

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 14 or higher."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm."
    exit 1
fi

echo "✅ Prerequisites check passed"
echo ""

# Setup Backend
echo "🔧 Setting up Django Backend..."
echo "==============================="

cd backend

# Create virtual environment
echo "📦 Creating Python virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Install Python dependencies
echo "📥 Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Copy environment file
if [ ! -f .env ]; then
    echo "📄 Creating environment file..."
    cp .env.example .env
    echo "⚠️  Please edit backend/.env file with your configuration"
fi

# Run database migrations
echo "🗄️  Running database migrations..."
python manage.py makemigrations
python manage.py migrate

# Create superuser (optional)
echo ""
read -p "🔐 Do you want to create a Django superuser? (y/n): " create_superuser
if [ "$create_superuser" = "y" ] || [ "$create_superuser" = "Y" ]; then
    python manage.py createsuperuser
fi

# Populate database with sample data
echo "📊 Populating database with sample data..."
python populate_remedies.py

echo "✅ Backend setup completed!"
echo ""

# Setup Frontend
cd ../frontend

echo "🔧 Setting up React Frontend..."
echo "==============================="

# Install Node.js dependencies
echo "📥 Installing Node.js dependencies..."
npm install

# Build the React app
echo "🏗️  Building React application..."
npm run build

echo "✅ Frontend setup completed!"
echo ""

# Final instructions
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "To start the application:"
echo ""
echo "1. Start the Django backend:"
echo "   cd backend"
echo "   source venv/bin/activate  # On Windows: venv\\Scripts\\activate"
echo "   python manage.py runserver 8000"
echo ""
echo "2. In a new terminal, start the React frontend:"
echo "   cd frontend"
echo "   npm start"
echo ""
echo "3. Access the application:"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:8000/api"
echo "   Django Admin: http://localhost:8000/admin"
echo ""
echo "📝 Don't forget to:"
echo "   - Edit backend/.env with your email settings"
echo "   - Configure any third-party API keys"
echo "   - Set up your production database if deploying"
echo ""
echo "🚀 Happy coding with THRIVEMIND!"
