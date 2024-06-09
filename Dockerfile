FROM python:3.10
COPY requirements.txt /
RUN pip3 install -r requirements.txt
RUN mkdir /the_python_project
WORKDIR /the_python_project
COPY app /the_python_project/app
ENV PYTHONPATH=/the_python_project:$PYTHONPATH
# comment next entrypoint for dev
ENTRYPOINT ["python3", "/the_python_project/app/app.py"]
# uncomment next entrypoint for dev mode
# ENTRYPOINT ["tail", "-f", "/dev/null"]
# execute:
# docker exec -it poc-data-live /bin/bash
# for dev and play
