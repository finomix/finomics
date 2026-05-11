# S3 Bucket Policy Reference

This document explains the bucket policy applied to the central Finomics S3 bucket that receives FOCUS data exports from every account in the AWS Organization.

## Overview

The bucket lives in the management account and receives FOCUS exports written by the AWS Data Exports service on behalf of every account in the org. The policy is intentionally tight: it grants the data-exports service principal write access, lets org members read the resulting objects, and denies everything else.

## Statements

| Statement Sid | What it does |
|---|---|
| `EnableAWSDataExportsToWriteToS3-AllOrgAccounts` | Grants `bcm-data-exports.amazonaws.com` permission to `PutObject` and `GetObject`. The wildcard (`*`) in the `SourceArn` account position covers ALL accounts in the org without listing them individually. Do NOT add `aws:PrincipalOrgID` here — it breaks validation for service principals. |
| `AllowOrgAccountsGetObject` | Allows any IAM principal within the org to read and list objects. This lets FinOps tools and Athena queries running in child accounts access the central export data directly. |
| `DenyNonOrgAccess` | Hard deny for any principal outside the org. `BoolIfExists: aws:PrincipalIsAWSService: false` exempts AWS service principals (like `bcm-data-exports`) so they are not blocked by this deny. |

## Notes & Gotchas

- **Service principals and `aws:PrincipalOrgID`** — Service principals are not part of an organization, so a `PrincipalOrgID` condition on a service-principal statement will always fail. Use `aws:SourceArn` / `aws:SourceAccount` instead to scope the service's access.
- **The `DenyNonOrgAccess` exemption** — `BoolIfExists` matches both when the key is present and false, and when the key is absent entirely. This is the standard pattern for "deny everyone outside the org except AWS services."
- **Order doesn't matter for evaluation** — IAM evaluates explicit denies before allows. The `DenyNonOrgAccess` statement always wins for non-org principals regardless of where it appears in the policy document.

## Related Files

- [s3-bucket-policy.json](s3-bucket-policy.json) — paste-ready JSON for the AWS console
- [finomics-tf-modules/s3/main.tf](finomics-tf-modules/s3/main.tf) — Terraform source of truth
