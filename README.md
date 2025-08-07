# Legacy Health Backend

A serverless TypeScript API built with AWS Lambda, API Gateway, and DynamoDB for Legacy Health's patient advocacy platform.

## 🏗️ Architecture

- **Runtime**: Node.js 18 + TypeScript
- **Function**: AWS Lambda with API Gateway integration
- **Database**: DynamoDB for patient data storage
- **Infrastructure**: Terraform for Infrastructure as Code
- **CI/CD**: GitHub Actions with automated deployment

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- npm or yarn
- AWS CLI configured
- Terraform 1.6+

### Local Development

```bash
# Install dependencies
npm install

# Start development server (with hot reload)
npm run dev

# Build TypeScript
npm run build

# Run tests
npm run test

# Lint code
npm run lint
```

### Testing the API

The Lambda function provides these endpoints:

- `GET /health` - Health check endpoint
- `GET /api/patients` - List all patients
- `POST /api/patients` - Create new patient

## ☁️ AWS Infrastructure

The Terraform configuration creates:

- **Lambda Function**: Serverless API handler
- **API Gateway**: HTTP API with CORS support
- **DynamoDB Table**: Patient data storage with GSI
- **IAM Role**: Lambda execution role with DynamoDB permissions
- **CloudWatch Logs**: Function logging

### Infrastructure Setup

1. **Configure Terraform variables**:
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Required Terraform Variables

```hcl
aws_region  = "us-west-2"      # AWS region
environment = "dev"            # Environment name
app_name    = "legacy-health-backend"  # Application name
```

## 🔄 CI/CD Pipeline

The GitHub Actions workflow automatically:

1. **On Pull Requests**:
   - Runs TypeScript build and tests
   - Runs ESLint for code quality
   - Generates Terraform plan

2. **On Main Branch Push**:
   - Builds and tests the application
   - Applies Terraform changes
   - Deploys Lambda function
   - Tests the deployed API

### Required GitHub Secrets

- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key

### Required GitHub Variables

- `AWS_REGION`: AWS region (default: us-west-2)
- `ENVIRONMENT`: Environment name (default: dev)

## 📁 Project Structure

```
├── src/                     # TypeScript source code
│   ├── index.ts            # Main Lambda handler
│   └── __tests__/          # Jest tests
├── terraform/              # Infrastructure as Code
│   ├── main.tf            # Main Terraform configuration
│   ├── variables.tf       # Input variables
│   └── outputs.tf         # Output values
├── .github/
│   └── workflows/
│       └── deploy.yml     # CI/CD pipeline
├── dist/                  # Compiled JavaScript (generated)
├── package.json           # Node.js dependencies and scripts
└── tsconfig.json         # TypeScript configuration
```

## 🛠️ Development Commands

```bash
npm run build        # Compile TypeScript to JavaScript
npm run dev          # Start development server with hot reload
npm run test         # Run Jest tests
npm run lint         # Run ESLint
npm run lint:fix     # Fix ESLint issues automatically
npm run package      # Build and create deployment zip
```

## 🧪 Testing

The project includes comprehensive Jest tests for:

- Health check endpoint
- CORS preflight handling
- Patient CRUD operations
- Error handling scenarios

Run tests with:
```bash
npm test                    # Run all tests
npm test -- --watch        # Run tests in watch mode
npm test -- --coverage     # Run tests with coverage report
```

## 📋 API Endpoints

### Health Check
```http
GET /health
```
Returns service status and version information.

### List Patients
```http
GET /api/patients
```
Returns a list of all patients (placeholder data).

### Create Patient
```http
POST /api/patients
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
```
Creates a new patient record.

## 🔧 Environment Variables

The Lambda function uses these environment variables:

- `ENVIRONMENT`: Current environment (dev/staging/prod)
- `VERSION`: Application version
- `PATIENTS_TABLE`: DynamoDB table name for patients

## 🔐 Security

- Lambda function runs with minimal IAM permissions
- API Gateway has CORS configured for web integration
- DynamoDB access is restricted to specific table operations
- CloudWatch logs are configured with 14-day retention

## 🚀 Deployment

### Manual Deployment

```bash
# Build the application
npm run build

# Deploy infrastructure
cd terraform
terraform apply

# The API Gateway URL will be output after deployment
```

### Automated Deployment

Push to the `main` branch to trigger automatic deployment via GitHub Actions.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run tests and linting
6. Submit a pull request