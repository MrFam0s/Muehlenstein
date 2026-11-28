# Mühlenstein 1.6 (20)

Mühlenstein runs on iPhone and iPad. It offers four Morris variants and offline computer play. Players can drag or tap to move, compare a historical move with an engine recommendation after a game, and use a fixed or automatically adjusted difficulty. The local recommendation stores a level and a result trend.

## Mainland China feature review · 28 November 2026

The move analysis replays the recorded board through the local Rust engine. Explanations use translated, predefined strings for board facts. The adaptive mode counts game results. Neither feature calls a generative service. The existing negative AI-generated-content declaration applies. [Engine and analysis](../App/Core/Engine.swift)

Local network play exchanges invitations, board actions and synchronization messages with one other device. The protocol offers no chat, publication of user media or public feed. The existing negative security-assessment declaration applies. [Network protocol](../App/Core/LocalMatchProtocol.swift)

Apple lists both existing forms as `COLLECTED_VERIFY_NOT_NECESSARY`. All 175 territories were selected at the release check. Apple's mainland China territory record separately reported `MISSING_GRN` for the game registration number. Actual availability there depends on Apple's regional requirements.
