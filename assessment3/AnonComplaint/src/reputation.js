import { ethers } from "ethers";
import ReputationABI from "./abis/reputation.json";

// Load the contract address from environment variables
const REPUTATION_ADDRESS = import.meta.env.VITE_REPUTATION_CALCULATION_ADDRESS;
let reputationContract;

// Initialize and get the contract instance
async function getContract()
{
  if (reputationContract) return reputationContract;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();
  reputationContract = new ethers.Contract(REPUTATION_ADDRESS, ReputationABI, signer);
  return reputationContract;
}

// Get the average score for an organisation
export async function getScore(orgRegistrationNumber)
{
  const contract = await getContract();
  const score = await contract.getScore(orgRegistrationNumber);
  return score.toString();
}
