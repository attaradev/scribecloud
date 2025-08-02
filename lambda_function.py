import os
import json
import logging
import boto3
import uuid
from datetime import datetime, timezone

s3 = boto3.client('s3')
translate = boto3.client('translate')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")

    request_bucket = os.environ.get('REQUEST_BUCKET')
    response_bucket = os.environ.get('RESPONSE_BUCKET')

    if not request_bucket or not response_bucket:
        logger.error("Missing environment variables.")
        return _response(500, {"error": "Server misconfiguration"})

    try:
        body = json.loads(event.get("body") or '{}')
        source_lang = body.get("source_language")
        target_lang = body.get("target_language")
        text_to_translate = body.get("text")

        if not source_lang or not target_lang or not text_to_translate:
            return _response(400, {"error": "Missing required parameters"})

        request_id = str(uuid.uuid4())
        timestamp = datetime.now(timezone.utc).isoformat()

        request_data = {
            "request_id": request_id,
            "timestamp": timestamp,
            "source_language": source_lang,
            "target_language": target_lang,
            "text": text_to_translate
        }

        # Step 1: Save original request to S3
        s3_key = f"{request_id}_request.json"
        s3.put_object(
            Bucket=request_bucket,
            Key=s3_key,
            Body=json.dumps(request_data),
            ContentType="application/json"
        )

        # Step 2: Perform translation
        response = translate.translate_text(
            Text=text_to_translate,
            SourceLanguageCode=source_lang,
            TargetLanguageCode=target_lang
        )
        translated_text = response.get('TranslatedText', '')

        result = {
            **request_data,
            "translated_text": translated_text
        }

        # Step 3: Save translation result to response bucket
        s3.put_object(
            Bucket=response_bucket,
            Key=f"{request_id}_response.json",
            Body=json.dumps(result),
            ContentType="application/json"
        )

        return _response(200, {
            "translated_text": translated_text,
            "request_id": request_id,
            "s3_key": s3_key
        })

    except Exception as e:
        logger.exception("Translation failed.")
        return _response(500, {"error": str(e)})

def _response(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body)
    }
