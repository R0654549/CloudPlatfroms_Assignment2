FROM python
ENV FLASK_APP=crudapp.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
WORKDIR /app
COPY . .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN flask db init 
RUN flask db migrate -m "entries table" 
RUN flask db upgrade

EXPOSE 5000

CMD ["flask", "run"]