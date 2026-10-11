import"./icon-BclkLKie.js";import"./icon-button-DCxda_7H.js";var e=[{title:`Learning pathway`,description:`A personalized skill pathway is not available yet. NIDAN currently stores a Number Systems diagnostic and school-recorded assignments; prerequisite progression is not connected.`,state:`current`,icon:`route`}],t=document.getElementById(`roadmap-timeline`);e.forEach((e,n)=>{let r=document.createElement(`div`);r.className=`timeline-node node-${e.state}`,r.style.opacity=`0`,r.style.transform=`translateX(-20px)`,r.style.animation=`fadeRight 0.4s ease-out ${n*.15}s forwards`,r.innerHTML=`
    <div class="timeline-dot ${e.state}"></div>
    <div class="timeline-content">
      <h3>
        <md-icon>${e.icon}</md-icon>
        ${e.title}
      </h3>
      <p>${e.description}</p>
    </div>
  `,t.appendChild(r)});var n=document.createElement(`style`);n.innerHTML=`
  @keyframes fadeRight {
    from { opacity: 0; transform: translateX(-20px); }
    to { opacity: 1; transform: translateX(0); }
  }
`,document.head.appendChild(n);