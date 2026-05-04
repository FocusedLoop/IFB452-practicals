import { registerOrganisation, getOrganisation } from './organisation';
import { createSignal } from 'solid-js';
import './app.css';

const App = () => {
  const [output, setOutput] = createSignal('');
  const [loading, setLoading] = createSignal(false);

  // Organisation
  const [orgName, setOrgName] = createSignal('');
  const [orgId, setOrgId] = createSignal('');

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
      </div>

      <pre class={`output ${loading() ? 'loading' : ''}`}>
        {loading() ? 'Processing transaction' : (output() || '')}
      </pre>
    </div>
  );
};

export default App;
