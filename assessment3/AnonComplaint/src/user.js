import { ethers } from "ethers";
import { UserRegistryABI } from "./abis";

const USER_REGISTRY_ADDRESS = import.meta.env.VITE_USER_REGISTRY_ADDRESS;

let userRegistry;

async function getContract() {
  if (userRegistry) return userRegistry;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();
  userRegistry = new ethers.Contract(USER_REGISTRY_ADDRESS, UserRegistryABI, signer);
  return userRegistry;
}

export async function registerUser(name) {
  const contract = await getContract();
  const transaction = await contract.registerUser(name);
  const receipt = await transaction.wait();
  return receipt.transactionHash;
}

export async function getUser(userId) {
  const contract = await getContract();
  const [id, name, wallet] = await contract.getUser(userId);
  return { id: id.toString(), name, wallet };
}

export async function getUserIdByWallet(walletAddress) {
  const contract = await getContract();
  const id = await contract.walletToUserId(walletAddress);
  return id.toString();
}