# terraform-gcp

## Create service account for Terraform Runner
**Grant Required Roles (Least Privilege)**

- Compute Admin: To create and manage the VM.
- Storage Admin: To read/write the Terraform state file in your bucket.

```bash
gcloud iam service-accounts create terraform-runner \
    --description="Service account for Terraform to manage infrastructure" \
    --display-name="Terraform Runner"
```

## Create Workload Identity Provider (Github)

```bash
# Create the Pool
gcloud iam workload-identity-pools create "github-actions-pool" \
    --project="YOUR_PROJECT_ID" \
    --location="global" \
    --display-name="GitHub Actions Pool"

# Get the full ID of the Workload Identity Pool
gcloud iam workload-identity-pools describe "github-actions-pool" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --format="value(name)"

# Create the Provider
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-actions-pool" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
  --attribute-condition="assertion.repository_owner == 'YOUR_GITHUB_USERNAME'" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Extract the Workload Identity Provider
gcloud iam workload-identity-pools providers describe "github-provider" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-actions-pool" \
  --format="value(name)"
```