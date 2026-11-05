create table ar_markers (
    marker_id INTEGER NOT  NULL,
    marker_type VARCHAR(10) NOT  NULL,
    CONSTRAINT ar_markers_pk primary key (marker_id),
    CONSTRAINT ar_markers_id_ck CHECK (
        marker_id >= 0
    ),
    CONSTRAINT ar_markers_type_ck CHECK (
        marker_type IN ('ARUCO')
    )
);

create table players (
    player_id INTEGER NOT NULL,
    player_name VARCHAR(20) NOT NULL,
    CONSTRAINT players_pk primary key (player_id),
    CONSTRAINT players_name_ck CHECK (
        player_name ~ '^[[:alpha:]][[:alpha:] ]{0,19}$'
    )
);

create table games (
	game_id INTEGER NOT NULL,
    game_num INTEGER NOT NULL,
    result_status VARCHAR(20) NOT NULL,
    CONSTRAINT games_pk primary key (game_id),
    CONSTRAINT games_num_uk UNIQUE (game_num),
    CONSTRAINT games_num_ck CHECK (
        game_num > 0
    ),
    CONSTRAINT games_status_ck CHECK (
        result_status IN ('IN_PROGRESS', 'WIN', 'DRAW')
    )
);

create table participants (
    game_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    CONSTRAINT participants_pk primary key (game_id, player_id),
    CONSTRAINT participants_game_fk FOREIGN KEY (game_id) references games (
        game_id
    ),
    CONSTRAINT player_link_fk FOREIGN KEY (player_id) references players (
        player_id
    )
);

create table cells (
    cell_id VARCHAR(2) NOT NULL,
    marker_id INTEGER,
    CONSTRAINT cells_pk primary key (cell_id),
    CONSTRAINT cells_marker_uk UNIQUE (marker_id),
    CONSTRAINT cells_marker_fk FOREIGN KEY (marker_id) references ar_markers (
        marker_id
    ),
    CONSTRAINT cells_cell_id_ck CHECK (
        cell_id ~ '^[A-C][1-3]$'
    )
);

create table pieces (
    piece_id VARCHAR(10) NOT NULL,
    player_id INTEGER NOT NULL,
    symbol CHAR(1) NOT NULL,
    marker_id INTEGER,
    CONSTRAINT pieces_pk primary key (piece_id),
    CONSTRAINT pieces_marker_uk UNIQUE (marker_id),
    CONSTRAINT piece_owner_fk FOREIGN KEY (player_id) references players (
        player_id
    ),
    CONSTRAINT piece_marker_fk FOREIGN KEY (marker_id) references ar_markers (
        marker_id
    ),
    CONSTRAINT pieces_symbol_ck CHECK (
        symbol IN ('X', 'O')
    )
);

create table moves (
    game_id INTEGER NOT NULL,
    move_seq SMALLINT NOT NULL,
    piece_id VARCHAR(10) NOT NULL,
    cell_id VARCHAR(2) NOT NULL,
    move_status VARCHAR(10) NOT NULL,
    CONSTRAINT moves_pk primary key (game_id, move_seq),
    CONSTRAINT moves_game_fk FOREIGN KEY (game_id) references games (
        game_id
    ),
    CONSTRAINT moves_piece_fk FOREIGN KEY (piece_id) references pieces (
        piece_id
    ),
    CONSTRAINT moves_cell_fk FOREIGN KEY (cell_id) references cells (
        cell_id
    ),
    CONSTRAINT moves_seq_ck CHECK (
        move_seq > 0
    ),
    CONSTRAINT moves_status_ck CHECK (
        move_status IN ('VALID', 'INVALID')
    )
)
