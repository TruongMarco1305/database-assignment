import { stringify as uuidStringify } from 'uuid';

export function convertUUIDtoBinaryHex(rawUUID: string): Buffer {
  return Buffer.from(rawUUID.replace(/-/g, ''), 'hex');
}

export function convertBinaryHexToUUID(binary: Buffer): string {
  return uuidStringify(binary);
}
