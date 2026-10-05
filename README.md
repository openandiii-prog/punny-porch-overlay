# punny-porch-overlay

Design overlay for The Punny Porch storefront. These are the store owner's own theme files
(page designs, the Halloween decorations and the home page sky), packed so they can be applied
to the store theme in one step and checked byte for byte.

Safe to delete once the store is live.

## What is in here

| File | What it is |
|---|---|
| `overlay.tgz` | 58 theme files at their theme paths: 25 replace existing design files, 33 are new under `components/porch/` and `public/punny/` |
| `MANIFEST.sha256` | what each of the 58 files must hash to once applied |
| `PREIMAGE.sha256` | what the 25 replaced files must hash to before applying, so a theme that changed since the overlay was built is refused instead of overwritten |
| `canary.tgz`, `CANARY.sha256` | three new files only, to test the delivery channel first |
| `SHA256SUMS` | hashes of the two archives |
| `apply.sh` | the apply step: verify, extract, verify again |

## Apply

From the theme root (the folder with `package.json` and `app/`):

```bash
mkdir -p /tmp/porch && curl -fsSL https://github.com/openandiii-prog/punny-porch-overlay/archive/main.tar.gz | tar -xz -C /tmp/porch --strip-components=1
bash /tmp/porch/apply.sh canary
bash /tmp/porch/apply.sh
```

`apply.sh` writes only the files listed in `MANIFEST.sha256`. It never deletes anything, running
it twice changes nothing, and it stops before copying if the archives are damaged or the theme
has drifted.

## What it never touches

`app/layout.tsx`, `app/providers.tsx`, `app/page.tsx`, `app/_generated/`, `package.json`, lockfiles,
`next.config.mjs`, hooks, lib, and every checkout, account, auth and policy file.

## Season switch

All Halloween decoration hangs off one constant in `components/porch/season.ts`.
Set `SEASON` to `'none'` and the store goes back to plain cream.
