<h1>🛡️ Debian Server Hardening & Best Practices</h1>

<p>This repository is a practical guide and a resource collection for securing and optimizing Debian servers. Here, you'll find hardening best practices, essential security configurations, and strategies to protect your servers against common threats.</p>

<p>Our goal is to provide clear steps and reusable scripts to ensure your Debian servers are configured with maximum security and resilience—whether for personal use, development, or production environments.</p>

<h2>🎯 What You'll Find Here</h2>

<h3>🔐 Secure SSH Configurations</h3>
<ul>
  <li>Instructions for setting up SSH following best practices, including key-based authentication, disabling root login, using non-standard ports, and limiting login attempts.</li>
  <li>Example <code>sshd_config</code> files and automation scripts.</li>
</ul>

<h3>👥 User & Permission Management</h3>
<ul>
  <li>Guidelines for secure user creation and management.</li>
  <li>Using <code>sudo</code> for privileged access and configuring file and directory permissions (<code>chmod</code>, <code>chown</code>).</li>
  <li>Strategies to restrict access to critical resources.</li>
</ul>

<h3>🔥 Firewall (UFW / nftables)</h3>
<ul>
  <li>Example firewall rules using UFW (Uncomplicated Firewall) to simplify configuration.</li>
  <li>Advanced setups with <code>nftables</code> for specific scenarios like service isolation or basic DDoS protection.</li>
</ul>

<h3>📝 Log Auditing & Monitoring (auditd / rsyslog)</h3>
<ul>
  <li>Configuration of <code>auditd</code> to audit key system events.</li>
  <li>Optimizing <code>rsyslog</code> for log collection and rotation.</li>
  <li>Tips for setting up alerts and integrating with basic SIEM (Security Information and Event Management) tools.</li>
</ul>

<h3>🔄 Security Updates & Maintenance</h3>
<ul>
  <li>Strategies for keeping the system and packages up to date automatically or on a schedule (e.g., <code>unattended-upgrades</code>).</li>
  <li>Best practices for package management and removing unnecessary software.</li>
</ul>

<h3>🧰 Additional Hardening Tools</h3>
<ul>
  <li>Documentation on installing and using tools like <strong>Fail2Ban</strong> to mitigate brute-force attacks.</li>
  <li><strong>Lynis</strong> for automated security auditing and <strong>chkrootkit</strong>/<strong>rkhunter</strong> for rootkit detection.</li>
</ul>

<h3>📚 Detailed Documentation</h3>
<ul>
  <li>Clear and concise step-by-step tutorials for each security measure, helping you implement configurations with confidence.</li>
  <li>Explanations of the security principles behind each recommendation.</li>
</ul>
