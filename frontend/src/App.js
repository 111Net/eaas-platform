import React, { useState } from "react";

export default function App() {
  const [user, setUser] = useState("");
  const [data, setData] = useState(null);

  const register = async () => {
    const res = await fetch(
      "http://localhost:8000/api/v1/auth/register?user=" + user,
      { method: "POST" }
    );
    setData(await res.json());
  };

  return (
    <div style={{padding:20}}>
      <h1>EAAS SaaS Platform</h1>

      <input value={user} onChange={e => setUser(e.target.value)} />
      <button onClick={register}>Register User</button>

      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
}
