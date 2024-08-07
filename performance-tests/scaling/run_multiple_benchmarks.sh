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
if [[ -n "$FHIR_SERVER_URL" ]]; then
  echo "ERROR: Comment out FHIR_SERVER_URL in config.sh if running multiple"
  exit 1
fi
if [[ -n "$BATCH_SIZE" ]]; then
  echo "ERROR: Comment out BATCH_SIZE in config.sh if running multiple"
  exit 1
fi
if [[ -n "$FLINK_PARALLEL" ]]; then
  echo "ERROR: Comment out FLINK_PARALLEL in config.sh if running multiple"
  exit 1
fi
if [[ -n "$DATAFLOW_WORKERS" ]]; then
  echo "ERROR: Comment out DATAFLOW_WORKERS in config.sh if running multiple"
  exit 1
fi

set -e # Fail on errors.
set -x # Show each command.
set -o nounset

for dataflow in $MULTIPLE_DATAFLOW_WORKERS; do
  for flink in $MULTIPLE_FLINK_PARALLEL; do
    for batch in $MULTIPLE_BATCH_SIZE; do
      for p in $MULTIPLE_PATIENTS; do
        for j in $MULTIPLE_JDBC_MODE; do
          for server in $MULTIPLE_FHIR_SERVER_URL; do
            for f in $MULTIPLE_FHIR_ETL_RUNNER; do
              export PATIENTS=$p
              export JDBC_MODE=$j
              export FHIR_ETL_RUNNER=$f
              export FHIR_SERVER_URL=$server
              export BATCH_SIZE=$batch
              export FLINK_PARALLEL=$flink
              export DATAFLOW_WORKERS=$dataflow
              if [ "$ENABLE_SETUP_GOOGLE3" = true ]; then
                ./setup_google3.sh
                sleep 15
              fi
              ./upload_download.sh
            done
          done
        done
      done
    done
  done
done