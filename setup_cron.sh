#!/bin/bash

# Configuration
CRON_JOB="*/10 * * * * php /var/www/laswow/index.php massmail admin process_queue"
# Alternative curl method (often more reliable)
# CRON_JOB="*/10 * * * * curl -s \"http://www.laswow.com/massmail/admin/process_queue/AzerothCronSecret2026\" > /dev/null"

echo "Attempting to register the following cron job:"
echo "$CRON_JOB"
echo ""

# Check if the job already exists
(crontab -l 2>/dev/null | grep -F "$CRON_JOB") && {
    echo "This cron job is already registered."
    exit 0
}

# Add the job to crontab
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

if [ $? -eq 0 ]; then
    echo "SUCCESS: Cron job has been registered."
    echo "You can verify it by running 'crontab -l'"
else
    echo "ERROR: Failed to register cron job. Please try manually via 'crontab -e'."
    exit 1
fi
