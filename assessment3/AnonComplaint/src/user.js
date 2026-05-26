import { ethers } from "ethers";
import UserRegistryABI from "./abis/user.json";

// Load the contract address from environment variables
const USER_REGISTRY_ADDRESS = import.meta.env.VITE_USER_REGISTRY_ADDRESS;
let userRegistry;

// Initialize and get the contract instance
async function getContract()
{
  if (userRegistry) return userRegistry;
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();
  userRegistry = new ethers.Contract(USER_REGISTRY_ADDRESS, UserRegistryABI, signer);
  return userRegistry;
}

// Register a new user with a name and return the transaction hash
export async function registerUser(name)
{
  const contract = await getContract();
  const transaction = await contract.registerUser(name);
  const receipt = await transaction.wait();
  return receipt.transactionHash;
}

// Get UserId to display after registration
export async function getMyUserId()
{
  const contract = await getContract();
  const userId = await contract.getMyUserId();
  return userId.toString();
}

// Verify the logged in wallet owns the User ID and return user details
export async function verifyLogin(userId)
{
    const contract = await getContract();
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signerAddress = await provider.getSigner().getAddress();
    const owned = await contract.isOwner(userId, signerAddress);
    if (!owned) throw new Error("This User ID does not belong to your wallet");
    const [id, name] = await contract.getUser(userId);
    return { id: id.toString(), name };
}