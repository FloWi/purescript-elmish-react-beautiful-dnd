module DragAndDrop where

import Prelude
import Data.Array (deleteAt, length, mapWithIndex, snoc)
import Data.Maybe (maybe)
import Data.UUID (UUID, genUUID)
import Debug (spy)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Elmish (ComponentDef, ReactElement, Transition, fork, handle)
import Elmish.HTML.Styled as H
import MyComponent (DragEndResult, dragDropContext, droppable)

data Message
  = AddSongToPlaylist Song
  | RemovePlaylistEntry Int
  | AddPlaylistEntryToPlaylist PlaylistEntry
  | DragAndDropEnd DragEndResult

type Song
  = { songId :: Int, title :: String }

type PlaylistEntry
  = { song :: Song, uuid :: String }
type State
  = { songs :: Array Song
    , playlist :: Array PlaylistEntry
    }

def :: forall m. MonadAff m => ComponentDef m Message State
def =
  { init:
      pure
        { songs:
            [ { songId: 1, title: "Bridge Burning" }
            , { songId: 2, title: "Rope" }
            , { songId: 3, title: "Dear Rosemary" }
            , { songId: 4, title: "White Limo" }
            , { songId: 5, title: "Arlandria" }
            , { songId: 6, title: "These Days" }
            , { songId: 7, title: "Back & Forth" }
            , { songId: 8, title: "A Matter Of Time" }
            , { songId: 9, title: "Miss The Misery" }
            , { songId: 10, title: "I Should Have Known" }
            , { songId: 11, title: "Walk" }
            ]
        , playlist:
            [ { song: { songId: 3, title: "Dear Rosemary" }, uuid: "E4F6F5E0-7E72-4FC2-8894-3F15852B5D18" }
            , { song: { songId: 3, title: "Dear Rosemary" }, uuid: "17A21829-7B13-4F5D-9212-6504F012B48C" }
            ]
        }
  , update
  , view
  }
  where
  update :: State -> Message -> Transition m Message State
  update s (DragAndDropEnd dragEndResult) =
    let
      _ = spy "DragEndResult" dragEndResult
    in
      pure s

  update s (AddSongToPlaylist song) = do
    fork
      $ do
          uuid <- liftAff $ generateUUID
          pure $ AddPlaylistEntryToPlaylist { song, uuid: show uuid }
    pure s
  update s (RemovePlaylistEntry playlistEntryIdx) = pure s { playlist = maybe [] identity $ deleteAt playlistEntryIdx s.playlist }
  update s (AddPlaylistEntryToPlaylist playlistEntry) = pure s { playlist = snoc s.playlist playlistEntry }

  view s dispatch =
    H.div ""
      $
        [ H.div "card"
            $ H.div "card-body"
            $ H.div "row"
                [ H.div "col-3"
                    [ H.div "" "Songs"
                    , H.h2 "" $ show $ length s.songs
                    ]
                , H.div "col-9" $ renderSongs s.songs
                ]
        , H.div "card"
            $ H.div "card-body"
            $ H.div "row"
                [ H.div "col-3"
                    [ H.div "" "Playlist"
                    , H.h2 "" $ show $ length s.playlist
                    ]
                , H.div "col-9" $ renderPlaylist s.playlist
                ]
        ]
    where
    renderSongs songs =
      songs
        # mapWithIndex \idx song ->
            H.div "card"
              $ H.div "card-body"
                  [ H.p "" $ show song.songId <> " " <> " " <> song.title
                  , H.button_ "btn btn-primary mb-2" { onClick: dispatch $ AddSongToPlaylist song } "Add Song"
                  ]
    renderPlaylist :: Array PlaylistEntry -> ReactElement
    renderPlaylist playlistEntries =
      dragDropContext { onDragEnd: handle dispatch \e -> DragAndDropEnd (spy "DragEnd" e) }
        $ droppable { droppableId: "playlist-droppable" } \{ provided, snapshot } -> H.text "Hello!" -- renderDroppableContent provided snapshot }

      where
      renderDroppableContent provided snapshot =
        H.div ""
          $ playlistEntries
          # mapWithIndex \idx playlistEntry ->
              H.div "card"
                $ H.div "card-body"
                $
                  [ H.p "" $ show playlistEntry.song.songId <> " " <> " " <> playlistEntry.song.title
                  , H.button_ "btn btn-primary mb-2" { onClick: dispatch $ RemovePlaylistEntry idx } "Remove Song"
                  ]

generateUUID :: Aff UUID
generateUUID =
  liftEffect genUUID
