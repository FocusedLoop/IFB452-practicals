import { ethers } from 'ethers';
import { OrgRegistryABI } from './abis';

const ORG_REGISTRY_ADDRESS = '0xYOUR_ORG_REGISTRY_ADDRESS';

let orgRegistry;

async function getContract() {
  if (orgRegistry) return orgRegistry;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send('eth_requestAccounts', []);
  const signer = provider.getSigner();
  orgRegistry = new ethers.Contract(ORG_REGISTRY_ADDRESS, OrgRegistryABI, signer);
  return orgRegistry;
}

export async function registerOrganisation(name) {
  const contract = await getContract();
  const tx = await contract.registerOrganisation(name);
  const r = await tx.wait();
  return r.transactionHash;
}

export async function getOrganisation(orgId) {
  const contract = await getContract();
  const [id, name, owner] = await contract.getOrganisation(orgId);
  return { id: id.toString(), name, owner };
}
