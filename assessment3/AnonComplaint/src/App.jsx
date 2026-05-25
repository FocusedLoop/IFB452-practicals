import { registerOrganisation, getOrganisation, listOrganisations } from "./organisation";
import { submitComplaint, getComplaints } from "./complaint";
import { registerUser, verifyLogin, getMyUserId } from "./user";
import { createSignal } from "solid-js";
import { getScore } from "./reputation";
import "./app.css";

const App = () => {
  // App state
  const [output, setOutput] = createSignal(""); // Output message
  const [loading, setLoading] = createSignal(false); // Handle loading

  // Organisation
  const [orgName, setOrgName] = createSignal("");
  const [orgRegistrationNumber, setOrgRegistrationNumber] = createSignal("");

  // User
  const [userName, setUserName] = createSignal("");
  const [userId, setUserId] = createSignal("");
  const [userDisplayName, setUserDisplayName] = createSignal("");

  // Complaint
  const [complaintOrgRegistrationNumber, setComplaintOrgRegistrationNumber] = createSignal("");
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
          <input placeholder="Business Registration Number (11 digits)" value={orgRegistrationNumber()} onInput={e => setOrgRegistrationNumber(e.target.value)} />
          <input placeholder="Organisation name" value={orgName()} onInput={e => setOrgName(e.target.value)} />
          <button onClick={() => run_action(async () => {
            const transaction = await registerOrganisation(orgRegistrationNumber(), orgName());
            setOutput("Organisation registered! Tx: " + transaction);
          })}>Register Organisation</button>

          <button onClick={() => run_action(async () => {
            const orgs = await listOrganisations();
            const rows = await Promise.all(orgs.map(async org => `Organisation: ${org.name} | ${org.registrationNumber} | Score: ${await getScore(org.registrationNumber)}/10`));
            setOutput(rows.join("\n"));
          })}>List Organisations</button>

          <button onClick={() => run_action(async () => {
            const org = await getOrganisation(orgRegistrationNumber());
            setOutput(`Business Registration Number: ${org.registrationNumber}\nName: ${org.name}\nScore: ${await getScore(org.registrationNumber)}/10`);
          })}>Get Organisation</button>
        </div>
        <div class="section">
          <h2>User Registry</h2>
          <input placeholder="Your name" value={userName()} onInput={e => setUserName(e.target.value)} />
          <button onClick={() => run_action(async () => {
            const transaction = await registerUser(userName());
            const newUserId = await getMyUserId();
            setOutput("User registered!\nName: " + userName() + "\nUser ID: " + newUserId + "\nTx: " + transaction + "\nNote your User ID to log in.");
          })}>Register User</button>

          <input placeholder="Enter your User ID" value={userId()} onInput={event => { setUserId(event.target.value); setUserDisplayName(""); }} />
          <button onClick={() => run_action(async () => {
            const user = await verifyLogin(userId());
            setUserDisplayName(user.name);
            setOutput("Logged in as " + user.name + " (User #" + userId() + ")");
          })}>Log In</button>
          <p>{userId() && userDisplayName() ? `Logged in as ${userDisplayName()}` : "Not logged in"}</p>
        </div>
        
        <div class="section">
          <h2>Complaints</h2>
          <input placeholder="Organisation Business Registration Number" value={complaintOrgRegistrationNumber()} onInput={e => setComplaintOrgRegistrationNumber(e.target.value)} />
          <input placeholder="Score (1-10)" value={complaintScore()} onInput={e => setComplaintScore(e.target.value)} />
          <input placeholder="Review" value={complaintReview()} onInput={e => setComplaintReview(e.target.value)} />
          <button onClick={() => run_action(async () => {
            if (!userId() || !userDisplayName()) throw new Error("You must be logged in to submit a complaint");
            const transaction = await submitComplaint(userId(), complaintOrgRegistrationNumber(), Number(complaintScore()), complaintReview());
            setOutput("Complaint submitted! Tx: " + transaction);
          })}>Submit Complaint</button>

          <button onClick={() => run_action(async () => {
            const complaints = await getComplaints(complaintOrgRegistrationNumber());
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
