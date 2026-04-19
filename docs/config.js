export const siteConfig = {
    demos: [
        {
            title: "PDF Document",
            description: "A standard visual document rendered as a fast page stream.",
            badge: "PDF",
            link: "#",
            thumbnailText: "PDF Preview"
        },
        {
            title: "Video Sequence",
            description: "A short video presented as scrubbable, inspectable frames.",
            badge: "Video",
            link: "#",
            thumbnailText: "Video Preview"
        },
        {
            title: "Slide Presentation",
            description: "PowerPoint or Keynote exported to a static step-by-step viewer.",
            badge: "Slides",
            link: "#",
            thumbnailText: "Presentation Preview"
        },
        {
            title: "Spreadsheet",
            description: "Wide, complex tables captured and flattened into simple page streams.",
            badge: "Excel",
            link: "#",
            thumbnailText: "Spreadsheet Preview"
        },
        {
            title: "Word Document",
            description: "Text-heavy documentation converted to static pages.",
            badge: "Word",
            link: "#",
            thumbnailText: "Document Preview"
        },
        {
            title: "BrowserBox Session",
            description: "A recorded browser session replayed as an interactive visual artifact.",
            badge: "Session Replay",
            link: "#",
            thumbnailText: "Session Preview"
        }
    ],
    faqs: [
        {
            q: "What is FlipBook?",
            a: "FlipBook is a utility that turns files and sessions into static directories of pages and frames, accompanied by a lightweight viewer. The output is highly scrubbable and fast to browse."
        },
        {
            q: "What kinds of content can it publish?",
            a: "Currently, FlipBook supports videos, PDFs, and Office documents (PowerPoint, Excel, Word). It also supports BrowserBox session recordings."
        },
        {
            q: "Does it require a server?",
            a: "No. FlipBook converts inputs into static HTML, CSS, JavaScript, and image assets. You can host the output anywhere static files live."
        },
        {
            q: "Where can I host the output?",
            a: "Cloudflare Pages, GitHub Pages, AWS S3, Vercel, Netlify, or any standard web server."
        },
        {
            q: "Is it open source?",
            a: "No. FlipBook is free to use, but not open source."
        },
        {
            q: "How does it relate to BrowserBox?",
            a: "FlipBook is built by the same team. It functions as a standalone utility, but can also parse and publish session recordings made using BrowserBox, which requires a BrowserBox license."
        }
    ]
};
