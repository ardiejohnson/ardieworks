// The portfolio-standard back-to-home pill. Every ardiejohnson.com app renders
// this in a strip at the very top of the page, ABOVE the app's own header, in
// normal flow — never position:fixed (a fixed pill overlaps apps with their own
// top bar). Canonical copy lives in the ardieworks repo (template/).
//
// Usage in App.tsx — swap #f5f8fb for the app's own background color:
//   <div className="home-strip" style={{ background: '#f5f8fb' }}>
//     <div style={{ maxWidth: 1120, margin: '0 auto', padding: '14px 20px 0' }}>
//       <HomeButton />
//     </div>
//   </div>
//   <TheApp />
//
// And in the global CSS:
//   @media print { .home-strip, .home-button { display: none !important; } }
export default function HomeButton() {
  return (
    <a
      href="https://ardiejohnson.com"
      aria-label="Back to ardiejohnson.com"
      className="home-button"
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 6,
        background: '#FFFFFF',
        border: '1px solid #E3E7EC',
        borderRadius: 999,
        padding: '5px 12px',
        fontSize: 12.5,
        fontWeight: 700,
        color: '#1B2330',
        textDecoration: 'none',
      }}
    >
      ← ardiejohnson.com
    </a>
  )
}
