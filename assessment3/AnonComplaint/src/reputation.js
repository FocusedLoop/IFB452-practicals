import { ethers } from "ethers";
import ReputationABI from "./abis/reputation.json";

const REPUTATION_ADDRESS = import.meta.env.VITE_REPUTATION_CALCULATION_ADDRESS;
let reputationContract;

async function getContract() {
  if (reputationContract) return reputationContract;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();
  reputationContract = new ethers.Contract(REPUTATION_ADDRESS, ReputationABI, signer);
  return reputationContract;
}

export async function getScore(orgAbn) {
  const contract = await getContract();
  const score = await contract.getScore(orgAbn);
  return score.toString();
}
