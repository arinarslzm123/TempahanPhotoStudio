import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const currentDir = path.dirname(fileURLToPath(import.meta.url));
const storageDir = path.resolve(currentDir, '../../storage');
const queueFile = path.join(storageDir, 'toyyibpay-callbacks.ndjson');

/**
 * Persists ToyyibPay callback payloads to a simple append-only queue file.
 * Storing as NDJSON keeps writes cheap and makes replay straightforward.
 */
export async function enqueueCallback(payload, context = {}) {
  const record = {
    receivedAt: new Date().toISOString(),
    payload,
    context
  };

  await fs.mkdir(storageDir, { recursive: true });
  await fs.appendFile(queueFile, JSON.stringify(record) + '\n');

  return record;
}
