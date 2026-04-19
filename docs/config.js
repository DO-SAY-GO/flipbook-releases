export const siteConfig = {
    demos: [
        {
            title: "Bitcoin Whitepaper",
            description: "The original Bitcoin paper rendered as a clean 9-page static document viewer.",
            badge: "PDF",
            link: "https://bitcoin-vhimg.pages.dev",
            thumbnailImage: "https://bitcoin-vhimg.pages.dev/pages/000001.jpg",
            thumbnailAlt: "Bitcoin whitepaper cover page in the FlipBook viewer",
            thumbnailText: "9 pages"
        },
        {
            title: "Elden Ring Weapons List",
            description: "A wide XLSX tiled into readable bands with frozen context preserved across pages.",
            badge: "XLSX",
            link: "https://elden-ring-weapons-list-37c13.pages.dev",
            thumbnailImage: "https://elden-ring-weapons-list-37c13.pages.dev/pages/000001.jpg",
            thumbnailAlt: "Elden Ring weapon spreadsheet rendered as a tiled FlipBook page",
            thumbnailText: "37 pages"
        },
        {
            title: "Daihatsu Hijet Service Manual",
            description: "A 909-page OCR service manual published as a static viewer without pagination lag.",
            badge: "Manual",
            link: "https://hijet-s100-s110-s120-s130-service-manual-2n1gf.pages.dev",
            thumbnailImage: "https://hijet-s100-s110-s120-s130-service-manual-2n1gf.pages.dev/pages/000001.jpg",
            thumbnailAlt: "Daihatsu Hijet service manual cover rendered in FlipBook",
            thumbnailText: "909 pages"
        },
        {
            title: "NuScale Investor Presentation",
            description: "A modern investor deck exported into a crisp slide-by-slide static presentation.",
            badge: "Slides",
            link: "https://nuscale-investor-presentation-cb1xn.pages.dev",
            thumbnailImage: "https://nuscale-investor-presentation-cb1xn.pages.dev/pages/000001.jpg",
            thumbnailAlt: "NuScale investor presentation cover slide in the FlipBook viewer",
            thumbnailText: "16 pages"
        },
        {
            title: "Swiss Village Short",
            description: "A vertical travel short converted into 438 scrubbable frames with video-style controls.",
            badge: "Video",
            link: "https://is-this-the-most-beautiful-village-in-th-tcnby.pages.dev",
            thumbnailImage: "https://is-this-the-most-beautiful-village-in-th-tcnby.pages.dev/pages/000183.jpg",
            thumbnailAlt: "A mountain village frame from a vertical travel video rendered in FlipBook",
            thumbnailText: "438 frames"
        },
        {
            title: "Neo Tokyo Motorcycle",
            description: "A short cyberpunk clip rendered into frame-accurate playback and fast visual scrubbing.",
            badge: "Video",
            link: "https://neo-tokyo-motorcycle-s08zm.pages.dev",
            thumbnailImage: "https://neo-tokyo-motorcycle-s08zm.pages.dev/pages/000073.jpg",
            thumbnailAlt: "A neon motorcycle frame from a cyberpunk video rendered in FlipBook",
            thumbnailText: "145 frames"
        },
        {
            title: "Steve Jobs Interview Clip",
            description: "A longer archival interview clip published as 1,224 frames for precise searching and replay.",
            badge: "Video",
            link: "https://steve-jobs-predicts-the-iphone-in-1981-x-4r4gn.pages.dev",
            thumbnailImage: "https://steve-jobs-predicts-the-iphone-in-1981-x-4r4gn.pages.dev/pages/000612.jpg",
            thumbnailAlt: "A Steve Jobs interview frame rendered in the FlipBook viewer",
            thumbnailText: "1,224 frames"
        },
        {
            title: "BrowserBox Flipbook Search Session",
            description: "A live BrowserBox browsing session exploring what a flipbook is across Google, Wikipedia, and FlipBook, published as a 2,340-frame replayable web artifact.",
            badge: "BrowserBox",
            link: "https://browser-session-8kd6i.pages.dev",
            thumbnailImage: "https://browser-session-8kd6i.pages.dev/pages/001200.jpg",
            thumbnailAlt: "A BrowserBox session browsing a flip book article and search results in FlipBook",
            thumbnailText: "2,340 frames"
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
