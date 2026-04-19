import { siteConfig } from './config.js';

document.addEventListener('DOMContentLoaded', () => {
    const demoContainer = document.getElementById('demo-container');
    if (demoContainer && siteConfig.demos) {
        siteConfig.demos.forEach((demo) => {
            const card = document.createElement('a');
            card.href = demo.link;
            card.className = 'demo-card';

            card.innerHTML = `
                <div class="demo-thumb">
                    <span>${demo.thumbnailText}</span>
                </div>
                <div class="demo-content">
                    <div class="demo-header">
                        <h3 class="demo-title">${demo.title}</h3>
                        <span class="demo-badge">${demo.badge}</span>
                    </div>
                    <p class="demo-desc">${demo.description}</p>
                </div>
            `;
            demoContainer.appendChild(card);
        });
    }

    const faqContainer = document.getElementById('faq-container');
    if (faqContainer && siteConfig.faqs) {
        siteConfig.faqs.forEach((faq) => {
            const item = document.createElement('div');
            item.className = 'faq-item';

            item.innerHTML = `
                <h3 class="faq-q">${faq.q}</h3>
                <p class="faq-a">${faq.a}</p>
            `;
            faqContainer.appendChild(item);
        });
    }
});
