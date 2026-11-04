import os
import numpy as np
import streamlit as st
from PIL import Image
from bead import make_pattern, build_pdf

st.set_page_config(page_title="Bead Pattern Maker | Handle Vault Beads", page_icon="🟣")
home = os.environ.get("HOME_URL", "")
if home:
    st.markdown(f"[← Handle Vault]({home})")
st.title("🟣 Bead Pattern Maker")
st.caption("Handle Vault Beads: turn any image into a fuse-bead pattern PDF (Perler, Hama and Artkal style). Files are processed in memory and not saved.")

up = st.file_uploader("Image", type=["png", "jpg", "jpeg", "webp", "gif", "bmp"])
title = st.text_input("Title", "My Bead Pattern", max_chars=60)
c1, c2, c3 = st.columns(3)
width = c1.number_input("Width in beads", 10, 87, 29)
colors = c2.number_input("Max colors", 2, 30, 10)
mm = c3.selectbox("Bead size", [5.0, 2.6], format_func=lambda v: "5 mm (standard)" if v == 5.0 else "2.6 mm (mini)")
remove_bg = st.checkbox("Remove plain background", value=True)
pixel_art = st.checkbox("Pixel-art mode (keeps hard edges)", value=False)

if st.button("Generate PDF", type="primary", disabled=up is None):
    with st.spinner("Building your pattern..."):
        try:
            grid, legend = make_pattern(up.getvalue(), int(width), int(colors), remove_bg, pixel_art)
            if not legend:
                st.error("Nothing left after background removal. Untick it and try again.")
            else:
                pdf = build_pdf(grid, legend, title or "Bead Pattern", 29, float(mm))
                st.session_state["bead"] = dict(pdf=pdf, grid=grid, legend=legend)
        except Exception as e:
            st.session_state.pop("bead", None)
            st.error(f"Could not process image: {e}")

r = st.session_state.get("bead")
if r:
    legend, grid = r["legend"], r["grid"]
    pal = np.array([l["rgb"] for l in legend] + [(255, 255, 255)], np.uint8)
    H, W = grid.shape
    st.image(Image.fromarray(pal[np.where(grid < 0, len(legend), grid)]).resize((W * 10, H * 10), Image.NEAREST),
             caption=f"{W} x {H} beads, {sum(l['count'] for l in legend)} beads in {len(legend)} colors")
    st.dataframe([{"Symbol": l["sym"], "Color": l["name"], "Beads": l["count"]} for l in legend], hide_index=True)
    st.download_button("Download PDF", r["pdf"], "bead-pattern.pdf", "application/pdf", type="primary")
st.divider()
st.link_button("☕ Support this tool", "https://ko-fi.com/handlevaultofficial")
st.divider()
st.link_button("☕ Support this tool", "https://ko-fi.com/yourname", type="primary")
