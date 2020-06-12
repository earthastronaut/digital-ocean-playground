FROM python:3

ENV PROJECT_DIR "/app"
ENV FLASK_APP simple_server
ENV FLASK_RUN_PORT 8080
ENV FLASK_RUN_HOST 0.0.0.0
ENV PYTHONPATH "${PROJECT_DIR}:${PYTHONPATH}"

WORKDIR $PROJECT_DIR

COPY requirements.txt .
RUN pip install -U pip setuptools wheel
RUN pip install -r requirements.txt

COPY . .

EXPOSE ${FLASK_RUN_PORT}
CMD ["flask", "run"]
