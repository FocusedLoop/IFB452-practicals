import { ethers } from "ethers";
import ComplaintRegistryABI from "./abis/complaint.json";

// Load the contract address from environment variables
const COMPLAINT_REGISTRY_ADDRESS = import.meta.env.VITE_COMPLAINT_REGISTRY_ADDRESS;
let complaintRegistry;

// Initialize and get the contract instance
async function getContract()
{
  if (complaintRegistry) return complaintRegistry;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();
  complaintRegistry = new ethers.Contract(COMPLAINT_REGISTRY_ADDRESS, ComplaintRegistryABI, signer);
  return complaintRegistry;
}

// Submit complaint for an organisation
export async function submitComplaint(userId, orgRegistrationNumber, score, review)
{
  const contract = await getContract();
  const tx = await contract.submitComplaint(userId, orgRegistrationNumber, score, review);
  const receipt = await tx.wait();
  const transactionHash = receipt.transactionHash;
  return transactionHash;
}

// Get complaints for an organisation
export async function getComplaints(orgRegistrationNumber)
{
  const contract = await getContract();
  const complaints = await contract.getComplaints(orgRegistrationNumber);
  const complaintList = complaints.map(complaint => ({
    id: complaint.id.toString(),
    userId: complaint.userId.toString(),
    orgRegistrationNumber: complaint.orgRegistrationNumber.toString(),
    score: complaint.score.toString(),
    timestamp: complaint.timestamp.toString(),
    review: complaint.review
  }));
  return complaintList;
}