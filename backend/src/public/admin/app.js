const statusEl = document.getElementById('status');
const ratesContainer = document.getElementById('ratesContainer');
const adminKeyInput = document.getElementById('adminKey');
const saveKeyBtn = document.getElementById('saveKeyBtn');
const reloadBtn = document.getElementById('reloadBtn');
const createForm = document.getElementById('createForm');

const newCurrency = document.getElementById('newCurrency');
const newName = document.getElementById('newName');
const newFlag = document.getElementById('newFlag');
const newBuy = document.getElementById('newBuy');
const newSell = document.getElementById('newSell');

const STORAGE_KEY = 'dinar_now_admin_key';

function getAdminKey() {
  return localStorage.getItem(STORAGE_KEY) || '';
}

function setAdminKey(value) {
  localStorage.setItem(STORAGE_KEY, value);
}

function setStatus(message, isError = false) {
  statusEl.textContent = message;
  statusEl.classList.toggle('error', isError);
}

function escapeHtml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

async function loadRates() {
  const adminKey = getAdminKey();

  if (!adminKey) {
    setStatus('Entre la clé admin puis clique sur Set.', true);
    ratesContainer.innerHTML = '';
    return;
  }

  setStatus('Chargement...');
  ratesContainer.innerHTML = '';

  try {
    const response = await fetch('/api/admin/rates', {
      headers: {
        'x-admin-key': adminKey,
      },
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.message || 'Failed to load rates.');
    }

    renderRates(data);
    setStatus(`Chargé (${data.length} devises).`);
  } catch (error) {
    setStatus(error.message || 'Erreur de chargement.', true);
  }
}

function renderRates(rows) {
  ratesContainer.innerHTML = rows
    .map((row) => {
      return `
        <form class="rate-row" data-currency="${escapeHtml(row.currency)}">
          <div class="rate-code">${escapeHtml(row.currency)}</div>

          <input name="name" type="text" value="${escapeHtml(row.name)}" />
          <input name="flag" type="text" value="${escapeHtml(row.flag)}" />
          <input name="buy" type="number" step="0.01" value="${escapeHtml(row.buy)}" />
          <input name="sell" type="number" step="0.01" value="${escapeHtml(row.sell)}" />

          <div class="rate-updated">${escapeHtml(row.updated_at || '')}</div>

          <button type="submit" class="primary-btn save-inline">Save</button>
        </form>
      `;
    })
    .join('');

  document.querySelectorAll('.rate-row').forEach((form) => {
    form.addEventListener('submit', async (event) => {
      event.preventDefault();

      const adminKey = getAdminKey();
      const currency = form.dataset.currency;
      const formData = new FormData(form);

      const payload = {
        currency,
        name: formData.get('name'),
        flag: formData.get('flag'),
        buy: Number(formData.get('buy') || 0),
        sell: Number(formData.get('sell') || 0),
      };

      setStatus(`Sauvegarde ${currency}...`);

      try {
        const response = await fetch('/api/admin/rates', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'x-admin-key': adminKey,
          },
          body: JSON.stringify(payload),
        });

        const data = await response.json();

        if (!response.ok) {
          throw new Error(data.message || 'Failed to save rate.');
        }

        setStatus(`${currency} sauvegardé.`);
        await loadRates();
      } catch (error) {
        setStatus(error.message || 'Erreur de sauvegarde.', true);
      }
    });
  });
}

saveKeyBtn.addEventListener('click', () => {
  const value = adminKeyInput.value.trim();

  if (!value) {
    setStatus('La clé admin est vide.', true);
    return;
  }

  setAdminKey(value);
  setStatus('Clé admin enregistrée localement.');
  loadRates();
});

reloadBtn.addEventListener('click', () => {
  loadRates();
});

createForm.addEventListener('submit', async (event) => {
  event.preventDefault();

  const adminKey = getAdminKey();
  if (!adminKey) {
    setStatus('Entre la clé admin avant d’enregistrer.', true);
    return;
  }

  const payload = {
    currency: newCurrency.value.trim().toUpperCase(),
    name: newName.value.trim(),
    flag: newFlag.value.trim() || '💱',
    buy: Number(newBuy.value || 0),
    sell: Number(newSell.value || 0),
  };

  if (!payload.currency || !payload.name) {
    setStatus('Code et nom obligatoires.', true);
    return;
  }

  setStatus(`Création / mise à jour ${payload.currency}...`);

  try {
    const response = await fetch('/api/admin/rates', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-admin-key': adminKey,
      },
      body: JSON.stringify(payload),
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.message || 'Failed to save rate.');
    }

    createForm.reset();
    setStatus(`${payload.currency} enregistré.`);
    await loadRates();
  } catch (error) {
    setStatus(error.message || 'Erreur lors de l’enregistrement.', true);
  }
});

adminKeyInput.value = getAdminKey();
if (getAdminKey()) {
  loadRates();
} else {
  setStatus('Entre la clé admin puis clique sur Set.', true);
}
