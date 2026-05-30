# The Impact of Conditional Cash Transfers on Maternal Autonomy in Nigeria

**Airah Balogun** · MS International and Development Economics · University of San Francisco · October 2025

---

## Overview

This paper evaluates the effect of Nigeria's **SURE-P MCH** (Subsidy Reinvestment & Empowerment Programme — Maternal and Child Health) conditional cash transfer program on women's household decision-making autonomy. Using a difference-in-differences design with three waves of DHS microdata, the study asks whether a major CCT program targeting maternal health improved women's autonomy in treated states relative to untreated states.

---

## Key Results

| Specification | DiD coefficient | p-value |
|--------------|----------------|---------|
| Short-run (2008 → 2013) | −0.006 | 0.57 |
| Long-run (2008 → 2018) | −0.007 | 0.48 |
| National trend 2013 → 2018 | +0.029 | < 0.01 |

The SURE-P program had **no statistically significant effect** on women's autonomy in treated states. The national improvement in autonomy between 2013 and 2018 reflects broader socioeconomic developments — rising female education and greater household participation — rather than the program's direct effects.

---

## Data and Methods

- **Survey data**: Nigeria DHS Individual Recode (IR) files — 2008 (pre-program), 2013 (short-run post), 2018 (long-run post)
- **Design**: Difference-in-differences (DiD) quasi-experiment
- **Treatment**: SURE-P implementation states — Anambra, Bauchi, Kaduna, Niger, Ondo, Zamfara
- **Outcome**: Women's autonomy index from three DHS items (healthcare decisions, large purchases, visits to relatives)
- **Controls**: Age, education, household wealth, urban residence, regional fixed effects
- **Estimation**: Weighted regressions using DHS sampling weights; standard errors clustered at state level

---

## Policy Implications

1. **Financial incentives alone are insufficient** to transform gender relations. The SURE-P cash transfer did not shift women's decision-making power within households.
2. **Complementary investments are required.** Sustained improvements in autonomy require parallel investments in education, information access, and gender-inclusive community programmes.
3. **CCTs need to be paired with social-norm interventions** that directly enhance women's capacity to make informed health and economic decisions.

---

## Citation

```
Balogun, A. (2025). The Impact of Conditional Cash Transfers (SURE-P MCH Program)
on Maternal Autonomy in Nigeria. IDEC, University of San Francisco.
```

---

## Replication

### Data Requirements

| Source | Files | Access |
|--------|-------|--------|
| Nigeria DHS (IR files) | NGIR53FL.DTA (2008), NGIR6AFL.DTA (2013), NGIR7AFL.DTA (2018) | Free account at [dhsprogram.com](https://dhsprogram.com/data) |

Raw DHS microdata are not included in this repository. Download the Nigeria Individual Recode files for 2008, 2013, and 2018 and place them in the `data/` directory.

### Code

| File | Description |
|------|-------------|
| `code/DHS Project.do` | Master do-file — runs full analysis |
| `code/DHS do.do` | Data cleaning and variable construction |

### Notes

- The autonomy index is constructed from DHS variables v743a, v743b, and v743d.
- DHS sampling weights (v005) are applied throughout.
- Standard errors are clustered at the state level.
