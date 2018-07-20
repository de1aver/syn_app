FROM node:latest as static

WORKDIR /app
COPY frontend_v3 /app
COPY frontend_v3/package*.json /app/
RUN npm install \
    && npm run build

FROM python:3.6-stretch as final
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
    wget \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main">>/etc/apt/sources.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update && \
    apt-get install -y bash \
    curl \
    postgresql-10 \
    tzdata

WORKDIR /app
#ADD backend_v3/requirments.txt /app
ADD backend_v3 /app
RUN pip install --upgrade pip && \
    pip install -r requirments.txt && \
    chmod 755 manage.py
COPY --from=static /app/dist/static /app/static

ENV TZ=Europe/Volgograd
EXPOSE 8000
CMD ["/app/manage.py", "runserver", "0.0.0.0:8000"]
