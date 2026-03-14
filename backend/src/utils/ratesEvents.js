const listeners = new Set();

function addListener(res) {
  listeners.add(res);
}

function removeListener(res) {
  listeners.delete(res);
}

function broadcastParallelRatesUpdated(payload = {}) {
  const data = `event: parallel-rates-updated\ndata: ${JSON.stringify({
    type: 'parallel-rates-updated',
    ...payload,
    timestamp: Date.now(),
  })}\n\n`;

  for (const res of listeners) {
    try {
      res.write(data);
    } catch (_) {
      listeners.delete(res);
    }
  }
}

module.exports = {
  addListener,
  removeListener,
  broadcastParallelRatesUpdated,
};
