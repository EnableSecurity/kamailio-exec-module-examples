INVITE sip:`$SIP_HF_COMMAND`@127.0.0.1 SIP/2.0
Command: {{ ENV "COMMAND" }}
Via: SIP/2.0/{{.AddrFamily}} {{.LocalAddr}};rport;branch=z9hG4bK-{{.Branch}}
Max-Forwards: 70
From: {{.FromVal}}
To: {{.ToVal}}
Call-ID: {{.CallID}}
CSeq: {{.CSeq}} INVITE
Contact: {{.ContactVal}}
Content-Length: {{.Body | len}}
Content-Type: application/sdp

{{.Body -}}