import { registerOrganisation, getOrganisation } from './organisation';
import { registerUser, getUser, getUserIdByWallet } from './user';
import { createSignal, onMount } from 'solid-js';
import { ethers } from 'ethers';
import './app.css';

const App = () => {
  const [output, setOutput] = createSignal('');
  const [loading, setLoading] = createSignal(false);

  // Organisation
  const [orgName, setOrgName] = createSignal('');
  const [orgId, setOrgId] = createSignal('');

  // User
  const [userName, setUserName] = createSignal('');
  const [userId, setUserId] = createSignal('');
  const [userDisplayName, setUserDisplayName] = createSignal('');

  // Auto detect user on load
  onMount(async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send('eth_requestAccounts', []);
    
    const wallet = await provider.getSigner().getAddress();
    const id = await getUserIdByWallet(wallet);

    // If already registered, set details in the UI
    if (id !== '0') {
      setUserId(id);
      const user = await getUser(id);
      setUserDisplayName(user.name);
    }
  });

  async function run(fn) {
    setLoading(true);
    setOutput('');
    try {
      await fn();
    } catch (e) {
      setOutput('Error: ' + (e.reason ?? e.message));
    } finally {
      setLoading(false);
    }
  }

  // TODO: GO BACK OVER ONCE CONTRACTS ARE FULLY COMPLETE

  // Current main page for all contracts
  return (
    <div class="app">
      <header>
        <h1>AnonComplaint</h1>
      </header>

      <div class="grid">
        <div class="section">
          <h2>Organisation Registry</h2>
          <input placeholder="Organisation name" value={orgName()} onInput={e => setOrgName(e.target.value)} />
          <button onClick={() => run(async () => {
            const tx = await registerOrganisation(orgName());
            setOutput('Organisation registered! Tx: ' + tx);
          })}>Register Organisation</button>

          <input placeholder="Organisation ID" value={orgId()} onInput={e => setOrgId(e.target.value)} />
          <button onClick={() => run(async () => {
            const org = await getOrganisation(orgId());
            setOutput(`Org #${org.id}\nName: ${org.name}\nOwner: ${org.owner}`);
          })}>Get Organisation</button>
        </div>
        <div class="section">
          <h2>User Registry</h2>
          <input placeholder="Your name" value={userName()} onInput={e => setUserName(e.target.value)} />
          <button onClick={() => run(async () => {
            const tx = await registerUser(userName());
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const wallet = await provider.getSigner().getAddress();
            const id = await getUserIdByWallet(wallet);
            setUserId(id);
            setUserDisplayName(userName());
            setOutput('User registered!\nName: ' + userName() + '\nYour ID: ' + id + '\nTx: ' + tx);
          })}>Register User</button>
          <p>{userId() ? `Logged in as ${userDisplayName()} (User #${userId()})` : 'Not registered'}</p>
        </div>
      </div>

      <pre class={`output ${loading() ? 'loading' : ''}`}>
        {loading() ? 'Processing transaction' : (output() || '')}
      </pre>
    </div>
  );
};

export default App;
