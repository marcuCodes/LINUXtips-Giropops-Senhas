FROM python:3.13.0-alpine AS build

LABEL AUTHOR="marcosmeireles359@gmail.com"

WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt


FROM gcr.io/distroless/python3

WORKDIR /app
COPY --from=build /usr/local/lib/python3.13/site-packages /usr/local/bin/python3.13/site-packages
COPY --from=build /app .

ENV FLASK_PORT=5000
EXPOSE $FLASK_PORT

ENTRYPOINT ["flask run --host=0.0.0.0 --port=$FLASK_PORT"]

HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:$FLASK_PORT || exit 1
