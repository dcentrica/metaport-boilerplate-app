# Metaport Boilerplate

A **GitHub specific** boilerplate Silverstripe 6 application wired up to notify a [Metaport](https://getmetaport.com/) server whenever a tagged release is pushed to GitHub.

* [Metaport docs](https://docs.metaport.sh/)
* [Metaport CE](https://gitlab.com/dcentrica/metaport/metaport-server)
* [Metaport on YouTube](https://youtube.com/@metaport)

There are several combinations you can use to ingest both EOL data and Dependency+Vulnerability data in Metaport:

| EOL&nbsp;Components | Comments | Dependencies&nbsp;&amp;&nbsp;Vulnerabilities | Comments | Metaport&nbsp;Source |
|---|---|---|---|---|
| VCS+CI |  | [DependencyTrack](https://dependencytrack.org) | Multiple sources (NVD, Sonatype, Github, OSV, & VulnDB) | `CI` |
| VCS+CI |  | [Dependabot](https://dependabot.com) | N/A | `CI` |
| Agent | Limited to `Runtime`, `Framework`, `OS` | Agent | Limited to package ecosystem capabilities e.g. `npm`, `composer` etc | `Cron` |
| Agent |  | [DependencyTrack](https://dependencytrack.org) | Multiple sources (NVD, Sonatype, Github, OSV, & VulnDB) | `Cron` |
| Agent |  | [Dependabot](https://dependabot.com) | N/A | `Cron` |

## Release signalling

### Payload

Metaport requires a minimal JSON payload to be sent for every action-trigger. The app-specific data to include is taken from Metaport itself using its [Developer Export](https://docs.metaport.sh/en/quickstart/#export-app-credentials-for-developers):

```json
{
  "format": "MetaportIngest",
  "version": "1.0",
  "data": {
    "identifier": "c8a96227-3460-48cb-8a86-34a4b5c3283a",
    "environment": "PROD",
    "domain": "my-app.xyz",
    "stack":"PHP/Composer",
    "version": "1.2.3",
    "source": "CI"
  }
}
```

**Notes:**

* When using Github actions, a `payload.json` file is written for you automatically (See the `.github` directory for the metaport workflow).
* The workflow at [.github/workflows/metaport-release.yml](.github/workflows/metaport-release.yml) triggers on any tag matching `v*` (e.g. `v1.2.3`) and `PUT`s the `MetaportIngest` payload.
* The payload schema, endpoint, and required headers are defined in the [Metaport EOL Manager docs](https://docs.metaport.sh/en/eolmanager/).

### Required GitHub secrets

Configure these under **Settings → Secrets and variables → Actions**:


| Secret | Source | Notes |
|---|---|---|
| `METAPORT_APP_API_TOKEN` | [Developer Export](https://docs.metaport.sh/en/quickstart/#export-app-credentials-for-developers) | Used as the `Authorization: Basic <token>` header. Token only needs `api` and `read` scopes. |
| `METAPORT_APP_IDENTIFIER` | [Developer Export](https://docs.metaport.sh/en/quickstart/#export-app-credentials-for-developers) | The application UUID (e.g. `c8a96227-3460-48cb-8a86-34a4b5c3283a`). |
| `METAPORT_APP_DOMAIN` | [Developer Export](https://docs.metaport.sh/en/quickstart/#export-app-credentials-for-developers) | Application domain (e.g. `my-app.xyz`). |
| `METAPORT_APP_ENVIRONMENT` | [Developer Export](https://docs.metaport.sh/en/quickstart/#export-app-credentials-for-developers) | e.g. `PROD`, `DEV`, `STAGE` etc. |
| `METAPORT_SERVER` | Use your own host for on-prem set-ups | N/A |

The `version` field is derived from the pushed tag (leading `v` stripped); `stack` is hard-coded to `PHP/Composer` and `source` to `CI`.

Note:

1. When creating an application record in Metaport, set the "Source" field to `CI`.

### Generating a Developer Export

The Developer Export bundles the identifier, domain, environment, and API token needed by this workflow. To generate one (per the [Metaport quickstart](https://docs.metaport.sh/en/quickstart/#export-app-credentials-for-developers)):

1. Log in to Metaport with any user role.
2. Navigate to the team that owns this application.
3. Open the **Applications** tab.
4. Click the row for this application.
5. Click the **Get Developer Export** icon.

The exported file contains **unencrypted** credentials — transfer it via a password vault or other secure channel, never email or chat.

## Cutting a release

```sh
git tag v1.2.3
git push origin v1.2.3
```

The workflow will fire on the tag push and notify Metaport. Check the Github Actions tab for the request status.
