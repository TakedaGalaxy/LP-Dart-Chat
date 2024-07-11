export class Api {
  url: string;
  isHttps: boolean

  constructor(url: string, isHttps: boolean) {
    this.url = url;
    this.isHttps = isHttps;
  }

  async signIn(name: string, password: string): Promise<string> {
    const response = await fetch(`http${this.isHttps ? "s" : ""}://${this.url}/api/user`, {
      method: "POST",
      headers: {
        "content-type": "application/json"
      },
      body: JSON.stringify({ name, password })
    });

    if (!response.ok)
      throw await response.text();

    return await response.text();
  }
}

const api = new Api("localhost:80", false);

export default api;