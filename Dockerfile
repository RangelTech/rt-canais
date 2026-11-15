FROM python:3.12-slim
WORKDIR /srv
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# ReLttk (MIT, Linkmail16/ReLttk-TikTok-Client-Bot) fixado por commit; roda só dentro do worker por conta (subprocesso do gateway).
ARG RELTTK_COMMIT=6483b27f441aaf13ebb3ad82b4c49014216a9733
RUN pip install --no-cache-dir websockets lz4 qrcode stealth-requests pycryptodome \
 && mkdir -p /opt/relttk && python -c "import io,tarfile,urllib.request,sys; \
u='https://github.com/Linkmail16/ReLttk-TikTok-Client-Bot/archive/%s.tar.gz' % sys.argv[1]; \
t=tarfile.open(fileobj=io.BytesIO(urllib.request.urlopen(u,timeout=60).read())); t.extractall('/opt/relttk'); \
import os; d=[x for x in os.listdir('/opt/relttk') if x.startswith('ReLttk')][0]; os.rename('/opt/relttk/'+d,'/opt/relttk/relttk')" ${RELTTK_COMMIT}
ENV PYTHONPATH=/opt/relttk
COPY app ./app
COPY migrations ./migrations
COPY tiktok_worker ./tiktok_worker
RUN useradd --system --uid 10001 --create-home app && mkdir -p /data/tiktok && chown -R 10001:10001 /data
ARG GIT_COMMIT=dev
ENV GIT_COMMIT=${GIT_COMMIT} PYTHONUNBUFFERED=1 TIKTOK_LAUNCHER=relttk TIKTOK_SESSIONS_DIR=/data/tiktok
USER 10001
EXPOSE 8100
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8100"]
