import { useEffect, useState } from "react";

function App() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch("/users")
      .then(res => res.json())
      .then(data => setUsers(data))
      .catch(err => console.error(err));
  }, []);

  return (
    <div>
      <h1>Users</h1>
      <ul>
        {users.map((user, i) => (
          <li key={i}>{user.name} - {user.role}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;