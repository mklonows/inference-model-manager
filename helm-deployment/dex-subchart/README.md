## Helm deployment of Dex

### Preparation to installation

You have to set all values specify in this chapter to properly run this chart
```issuer: "none" - issuer must be the same like in dex config
   config:
     <There you can put your dex config>
   resources: {} - it`s optionall, if you want you can specify resources for dex
```

Platform required ssl to internal traffic. We recommend to use for this purpose our script ```internal_ing_dex_certs.sh``` located in ```certs``` directory.

### Installation

To install this chart after preparation phase use:
```helm install .```