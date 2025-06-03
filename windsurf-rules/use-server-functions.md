---
trigger: model_decision
description: use server functions for any api needs
---

Anytime we need to create an api endpoint to allow some mutation backend action from the frontend, use a server function. Store them in `src\server\actions`

ex:

```js
"use server";

export async function createNote() {
  await db.notes.create();
}
```

these can then be used from the frontend. ex:

```js
"use client";
import {createNote} from './server/actions';

function EmptyNote() {
  <button onClick={() => createNote()} />
}
```

IMPORTANT: This should only be used for POST type server actions (ex adding something to a database). 