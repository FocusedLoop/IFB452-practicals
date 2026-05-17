import { registerOrganisation, getOrganisation, listOrganisations } from "./organisation";
import { submitComplaint, getComplaints } from "./complaint";
import { registerUser, getUser } from "./user";
import { createSignal } from "solid-js";
import { getScore } from "./reputation";
import "./app.css";

const App = () => {
  // App state
  const [output, setOutput] = createSignal(""); // Output message
  const [loading, setLoading] = createSignal(false); // Handle loading

  // Organisation
  const [orgName, setOrgName] = createSignal("");
  const [orgAbn, setOrgAbn] = createSignal("");

  // User
  const [userName, setUserName] = createSignal("");
  const [userId, setUserId] = createSignal("");
  const [userDisplayName, setUserDisplayName] = createSignal("");

  // Complaint
  const [complaintOrgAbn, setComplaintOrgAbn] = createSignal("");
  const [complaintScore, setComplaintScore] = createSignal("");
  const [complaintReview, setComplaintReview] = createSignal("");

  // Async function runner to handle the app state while waiting for transactions to process
  async function run_action(function_to_run) {
    setLoading(true);
    setOutput("");
    try {
      await function_to_run();
    } catch (error) {
      setOutput("Error: " + (error.reason ?? error.message));
    } finally {
      setLoading(false);
    }
  }

  // Current main page for all contracts
  return (
    <div class="app">
      <header>
        <h1>AnonComplaint</h1>
      </header>

      <div class="grid">
        <div class="section">
          <h2>Organisation Registry</h2>
          <input placeholder="ABN (11 digits)" value={orgAbn()} onInput={e => setOrgAbn(e.target.value)} />
          <input placeholder="Organisation name" value={orgName()} onInput={e => setOrgName(e.target.value)} />
          <button onClick={() => run_action(async () => {
            const transaction = await registerOrganisation(orgAbn(), orgName());
            setOutput("Organisation registered! Tx: " + transaction);
          })}>Register Organisation</button>

          <button onClick={() => run_action(async () => {
            const orgs = await listOrganisations();
            const rows = await Promise.all(orgs.map(async org => `ABN: ${org.abn} | ${org.name} | Score: ${await getScore(org.abn)}/10`));
            setOutput(rows.join("\n"));
          })}>List Organisations</button>

          <input placeholder="ABN to look up" value={orgAbn()} onInput={e => setOrgAbn(e.target.value)} />
          <button onClick={() => run_action(async () => {
            const org = await getOrganisation(orgAbn());
            setOutput(`ABN: ${org.abn}\nName: ${org.name}`);
          })}>Get Organisation</button>
        </div>
        <div class="section">
          <h2>User Registry</h2>
          <input placeholder="Your name" value={userName()} onInput={e => setUserName(e.target.value)} />
          <button onClick={() => run_action(async () => {
            const transaction = await registerUser(userName());
            setOutput("User registered!\nName: " + userName() + "\nTx: " + transaction + "\nNote your User ID to log in.");
          })}>Register User</button>

          <input placeholder="Enter your User ID" value={userId()} onInput={event => { setUserId(event.target.value); setUserDisplayName(""); }} />
          <button onClick={() => run_action(async () => {
            const user = await getUser(userId());
            setUserDisplayName(user.name);
            setOutput("Logged in as " + user.name + " (User #" + userId() + ")");
          })}>Log In</button>
          <p>{userId() && userDisplayName() ? `Logged in as ${userDisplayName()}` : "Not logged in"}</p>
        </div>
        
        <div class="section">
          <h2>Complaints</h2>
          <input placeholder="Organisation ABN" value={complaintOrgAbn()} onInput={e => setComplaintOrgAbn(e.target.value)} />
          <input placeholder="Score (1-10)" value={complaintScore()} onInput={e => setComplaintScore(e.target.value)} />
          <input placeholder="Review" value={complaintReview()} onInput={e => setComplaintReview(e.target.value)} />
          <button onClick={() => run_action(async () => {
            const transaction = await submitComplaint(userId(), complaintOrgAbn(), complaintScore(), complaintReview());
            setOutput("Complaint submitted! Tx: " + transaction);
          })}>Submit Complaint</button>

          <button onClick={() => run_action(async () => {
            const complaints = await getComplaints(complaintOrgAbn());
            setOutput(complaints.map(complaint => `#${complaint.id} | Score: ${complaint.score} | Review: ${complaint.review}`).join("\n"));
          })}>Get Complaints</button>
        </div>
      </div>

      <pre class={`output ${loading() ? "loading" : ""}`}>
        {loading() ? "Processing transaction" : (output() || "")}
      </pre>
    </div>
  );
};

export default App;
