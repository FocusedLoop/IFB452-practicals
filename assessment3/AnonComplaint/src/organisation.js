import { ethers } from 'ethers';
import OrgRegistryABI from './abis/org.json';

const ORG_REGISTRY_ADDRESS = import.meta.env.VITE_ORG_REGISTRY_ADDRESS;
let orgRegistry;

async function getContract() {
  if (orgRegistry) return orgRegistry;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send('eth_requestAccounts', []);
  const signer = provider.getSigner();
  orgRegistry = new ethers.Contract(ORG_REGISTRY_ADDRESS, OrgRegistryABI, signer);
  return orgRegistry;
}

// Register a new organisation with ABN
export async function registerOrganisation(abn, name) {
  const contract = await getContract();
  const transaction = await contract.registerOrganisation(abn, name);
  const receipt = await transaction.wait();
  return receipt.transactionHash;
}

// List
export async function listOrganisations() {
  const contract = await getContract();
  const orgs = await contract.listOrganisations();
  const organisationList = orgs.map(org => ({ abn: org.abn.toString(), name: org.name, owner: org.owner }));
  return organisationList;
}

// Get by ABN
export async function getOrganisation(desired_abn) {
  const contract = await getContract();
  const [abn, name, owner] = await contract.getOrganisation(desired_abn);
  const organisation = { abn: abn.toString(), name, owner };
  return organisation;
}