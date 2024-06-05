source config.sh

if [[ -n "$PATIENTS" ]]; then
  echo "ERROR: Comment out PATIENTS in config.sh if running multiple"
  exit 1
fi
if [[ -n "$JDBC_MODE" ]]; then
  echo "ERROR: Comment out JDBC_MODE in config.sh if running multiple"
  exit 1
fi
if [[ -n "$FHIR_ETL_RUNNER" ]]; then
  echo "ERROR: Comment out FHIR_ETL_RUNNER in config.sh if running multiple"
  exit 1
fi

set -e # Fail on errors.
set -x # Show each command.
set -o nounset

for p in $MULTIPLE_PATIENTS; do
  for j in $MULTIPLE_JDBC_MODE; do
    for f in $MULTIPLE_FHIR_ETL_RUNNER; do
      export PATIENTS=$p
      export JDBC_MODE=$j
      export FHIR_ETL_RUNNER=$f
      ./setup_google3.sh
      sleep 15
      ./upload_download.sh
    done
  done
done