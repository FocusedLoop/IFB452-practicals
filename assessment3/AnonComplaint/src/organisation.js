import { ethers } from "ethers";
import OrgRegistryABI from "./abis/org.json";

// Load the contract address from environment variables
const ORG_REGISTRY_ADDRESS = import.meta.env.VITE_ORG_REGISTRY_ADDRESS;
let orgRegistry;

// Initialize and get the contract instance
async function getContract()
{
  if (orgRegistry) return orgRegistry;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();
  orgRegistry = new ethers.Contract(ORG_REGISTRY_ADDRESS, OrgRegistryABI, signer);
  return orgRegistry;
}

// Register a new organisation with organisation number and name
export async function registerOrganisation(orgRegistrationNumber, name)
{
  const contract = await getContract();
  const transaction = await contract.registerOrganisation(orgRegistrationNumber, name);
  const receipt = await transaction.wait();
  return receipt.transactionHash;
}

// List all organisations with their registration numbers and names
export async function listOrganisations()
{
  const contract = await getContract();
  const orgs = await contract.listOrganisations();
  const organisationList = orgs.map(org => ({ registrationNumber: org.registrationNumber.toString(), name: org.name }))
  return organisationList;
}

// Get by orgRegistrationNumber
export async function getOrganisation(desired_orgRegistrationNumber)
{
  const contract = await getContract();
  const [registrationNumber, name] = await contract.getOrganisation(desired_orgRegistrationNumber);
  const organisation = { registrationNumber: registrationNumber.toString(), name };
  return organisation;
}