# IPDomainBlock:
This is just a simple Batch script which configures Windows IPSec policies to block specific IP addresses and IP ranges, and also modifies the hosts file to block specified domains by redirecting them to 0.0.0.0. It's designed to be easy to configure and run on Windows systems with admin privileges.

---

### Features:
- Blocks individual IP addresses using IPSec policies.
- Blocks IP ranges using IPSec policies.
- Blocks domains by adding entries to the Windows hosts file.
- Skips empty lists to avoid unnecessary processing.
- Includes cleanup instructions for reverting changes.

#

### Requirements:
- Windows OS (tested on Windows 10 and Windows 11).
- Admin privileges to run the script (required for modifying IPSec policies and the hosts file).

#

### Usage:
1. **Download the script**:
   - Clone or download this repository to your local machine.

2. **Configure the script**:
   - Open `block_script.bat` in a text editor.
   - Modify the following variables to specify the IPs, IP ranges, and domains to block:
     ```batch
     set "BLOCKED_IPS=192.168.1.1 192.168.1.5 192.168.1.10"
     set "BLOCKED_RANGES=192.168.10.0-192.168.10.255"
     set "BLOCKED_DOMAINS=DOMAIN1.COM DOMAIN2.COM DOMAIN3.COM"
     ```
     - Replace the example values with your desired IPs, ranges, or domains.
     - Leave a list empty (e.g., `set "BLOCKED_IPS="`) to skip processing it.

3. **Run the script**:
   - Open Command Prompt as an Administrator.
   - Navigate to the script's directory: `cd path\to\script`.
   - Run the script: `block_script.bat`.
   - The script will:
     - Create an IPSec policy to block specified IPs and IP ranges (if any).
     - Append domain blocks to `%SystemRoot%\System32\drivers\etc\hosts` (if any).
     - Display "Script completed successfully" upon completion.

#

### Cleanup:
To remove the changes made by the script:
- **IPSec Policy**:
  - Open Command Prompt as an Administrator.
  - Run: `netsh ipsec static delete policy name=BlockPolicy`
- **Hosts File**:
  - Open `%SystemRoot%\System32\drivers\etc\hosts` in a text editor (with admin rights).
  - Remove the lines added by the script (marked with `# Added by BlockScript`).

#

### Notes:
- The script must be run with admin privileges.
- Domain blocking redirects to `0.0.0.0`, effectively preventing access.
- Make sure you have backups of the hosts file before running the script.
