export class Api {
  url: string;
  isHttps: boolean

  constructor(url: string, isHttps: boolean) {
    this.url = url;
    this.isHttps = isHttps;
  }

  async signIn(name: string, password: string): Promise<string> {
    const data = new FormData();

    data.set("name", name);
    data.set("password", password);

    const response = await fetch(`http${this.isHttps && "s"}:${this.url}/api/user`, {
      method: "POST",
      body: data
    });

    if (!response.ok)
      throw await response.text();

    return await response.text();
  }
}

const api = new Api("localhost:8080", false);

export default api;